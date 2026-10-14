'use strict';

importScripts('config.js');

const CFG = globalThis.RESORT_HOST_RELAY_CONFIG;
const RELAY_VERSION = '0.1.1';

function fail(code, message) {
  return {
    ok: false,
    relay_version: RELAY_VERSION,
    http_status: null,
    error: { code, message },
  };
}

function stableProjectId(urlText) {
  try {
    const u = new URL(urlText);
    if (u.origin !== 'https://chatgpt.com') return null;
    const match = String(u.pathname || '').match(/^\/g\/(g-p-[0-9a-f]{32})(?=[\/-]|$)/i);
    return match ? String(match[1]).toLowerCase() : null;
  } catch {
    return null;
  }
}

async function callBridge(kind, bridgeRequest) {
  if (!CFG || !CFG.token || !CFG.expectedProjectId || !CFG.healthUrl || !CFG.requestUrl) {
    return fail('RELAY_CONFIG_INVALID', 'config.js is missing or incomplete');
  }

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 45000);

  try {
    const isHealth = kind === 'health';
    const url = isHealth ? CFG.healthUrl : CFG.requestUrl;
    const init = {
      method: isHealth ? 'GET' : 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Resort-Bridge-Token': CFG.token,
        'X-Resort-ChatGPT-Project': CFG.expectedProjectId,
      },
      cache: 'no-store',
      signal: controller.signal,
    };
    if (!isHealth) init.body = JSON.stringify(bridgeRequest || {});

    const res = await fetch(url, init);
    let payload = null;
    try { payload = await res.json(); } catch {}

    return {
      ok: res.ok,
      relay_version: RELAY_VERSION,
      http_status: res.status,
      bridge_response: payload,
      ...(res.ok ? {} : {
        error: {
          code: `HTTP_${res.status}`,
          message: payload?.error || res.statusText || 'bridge request failed',
        },
      }),
    };
  } catch (error) {
    return fail(
      error?.name === 'AbortError' ? 'BRIDGE_TIMEOUT' : 'BRIDGE_FETCH_FAILED',
      String(error?.message || error)
    );
  } finally {
    clearTimeout(timeout);
  }
}

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (!message || message.kind !== 'resort-host-relay') return false;

  const senderProject = stableProjectId(sender?.tab?.url || sender?.url || '');
  const pageProject = String(message?.page?.project_id || '').toLowerCase();

  if (senderProject !== CFG.expectedProjectId || pageProject !== CFG.expectedProjectId) {
    sendResponse(fail(
      'PAGE_PROJECT_MISMATCH',
      `sender=${senderProject || 'null'} page=${pageProject || 'null'} expected=${CFG.expectedProjectId}`
    ));
    return false;
  }

  if (message?.page?.origin !== 'https://chatgpt.com') {
    sendResponse(fail('PAGE_ORIGIN_MISMATCH', 'Relay request origin mismatch.'));
    return false;
  }

  const requestKind = String(message?.request?.kind || '');
  if (requestKind !== 'health' && requestKind !== 'bridge.request') {
    sendResponse(fail('RELAY_KIND_UNSUPPORTED', requestKind));
    return false;
  }

  callBridge(requestKind, message?.request?.bridge_request || null)
    .then(sendResponse)
    .catch(error => sendResponse(fail('RELAY_UNEXPECTED', String(error?.message || error))));
  return true;
});

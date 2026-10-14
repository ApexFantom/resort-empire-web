(() => {
  'use strict';

  const CHANNEL = 'resort-host-bridge';
  const REQUEST_SCHEMA = 'resort-host-relay-request/v1';
  const RESPONSE_SCHEMA = 'resort-host-relay-response/v1';
  const READY_SCHEMA = 'resort-host-relay-ready/v1';
  const EXPECTED_PROJECT = 'g-p-69251a10d1388191bbf4fa0ebd73adbd';
  const VERSION = '0.1.1';

  function observedProjectId() {
    const match = String(location.pathname || '').match(/^\/g\/(g-p-[0-9a-f]{32})(?=[\/-]|$)/i);
    return match ? String(match[1]).toLowerCase() : null;
  }

  function mark(state, detail = '') {
    const apply = () => {
      const root = document.documentElement;
      if (!root) return false;
      root.setAttribute('data-resort-host-relay', VERSION);
      root.setAttribute('data-resort-host-relay-state', String(state || 'unknown'));
      root.setAttribute('data-resort-host-relay-project', String(observedProjectId() || ''));
      if (detail) root.setAttribute('data-resort-host-relay-detail', String(detail).slice(0, 300));
      return true;
    };
    if (!apply()) {
      document.addEventListener('DOMContentLoaded', apply, { once: true });
    }
  }

  function allowedPage() {
    return location.origin === 'https://chatgpt.com' && observedProjectId() === EXPECTED_PROJECT;
  }

  mark('injected');

  if (!allowedPage()) {
    mark('project-mismatch', `${location.origin}${location.pathname}`);
    return;
  }

  function announceReady() {
    mark('ready');
    window.postMessage({
      schema: READY_SCHEMA,
      channel: CHANNEL,
      version: VERSION,
      project_id: EXPECTED_PROJECT,
    }, location.origin);
  }

  window.addEventListener('message', async event => {
    // Do not require event.source === window here: Chromium isolated worlds can
    // wrap the WindowProxy differently. Origin + channel + schema are the gate.
    if (event.origin !== location.origin) return;

    const data = event.data;
    if (!data || data.channel !== CHANNEL || data.schema !== REQUEST_SCHEMA) return;

    const clientRequestId = String(data.client_request_id || '');
    if (!clientRequestId) return;

    announceReady();
    mark('request-received', String(data.kind || ''));

    let response;
    try {
      response = await chrome.runtime.sendMessage({
        kind: 'resort-host-relay',
        page: {
          origin: location.origin,
          pathname: location.pathname,
          project_id: observedProjectId(),
        },
        request: {
          kind: String(data.kind || ''),
          bridge_request: data.bridge_request || null,
        },
      });
      mark(response?.ok === true ? 'response-ok' : 'response-error', response?.error?.code || '');
    } catch (error) {
      mark('runtime-error', String(error?.message || error));
      response = {
        ok: false,
        relay_version: VERSION,
        http_status: null,
        error: {
          code: 'EXTENSION_RUNTIME_FAILURE',
          message: String(error?.message || error),
        },
      };
    }

    window.postMessage({
      schema: RESPONSE_SCHEMA,
      channel: CHANNEL,
      client_request_id: clientRequestId,
      response,
    }, location.origin);
  });

  announceReady();
})();

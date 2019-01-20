const GAP_WIDTH = 20;
const elements = {};
const currentChapter = {
  path: null,
  pageIndex: 0,
  pageCount: 0,
  pageWidth: 0,
  contentWidth: 0,
};

const MESSAGE = 'EPUB';

const sendMessage = (message) => {
  const { callHandler } = window.flutter_inappbrowser || {};

  if (!callHandler) return;
  callHandler(MESSAGE, message);
};

const onContentLoaded = (fn) => {
  if (document.readyState === 'loading') { // Loading hasn't finished yet
    document.addEventListener('DOMContentLoaded', fn);
  } else { // `DOMContentLoaded` has already fired
    fn();
  }
};

onContentLoaded(() => {
  Object.assign(elements, {
    chapter: document.getElementById('chapter'),
    content: document.getElementById('content'),
    theme: document.getElementById('theme'),
  });
  document.body.addEventListener('click', (e) => {
    sendMessage({ type: 'PRESSED', x: e.screenX, y: e.screenY });
  });
});

const ping = () => {
  const { callHandler } = window.flutter_inappbrowser || {};

  console.log('ping');
  if (callHandler) {
    callHandler(MESSAGE, { type: 'PING' });
  }
  return 'ping';
}

const downloadChapter = async (path) => {
  try {
    const res = await fetch(path);
    if (!res.ok) throw Error(`status = ${res.status}`);
    return (new window.DOMParser()).parseFromString(await res.text(), 'text/html');
  } catch (e) {
    return e;
  }
};

function updateInfo() {
  const { chapter, content } = elements;
  const contentWidth = content.scrollWidth;
  const pageWidth = chapter.clientWidth + GAP_WIDTH;
  const pageCount = (contentWidth + GAP_WIDTH) / pageWidth;
  Object.assign(currentChapter, { pageCount, pageWidth, contentWidth });
}

const buildOffset = () => {
  const { pageWidth, pageIndex } = currentChapter;
  return `left: -${pageIndex * pageWidth}px`;
};

const goPage = (pageIndex = 0) => {
  const { pageCount } = currentChapter;
  const page = pageIndex < 0 ? pageIndex + pageCount : pageIndex;
  if (page < 0 || page >= pageCount) {
    return '';
  }

  const { content } = elements;
  currentChapter.pageIndex = page;
  content.setAttribute('style', `${buildOffset()}; visibility: visible`);
  return page.toString();
};

const updateChapter = (count) => {
  if (count > 3) {
    window.history.replaceState(null, '', '/');
    console.timeEnd('updateInfo');
    sendMessage({ type: 'CHAPTER_LOADED', currentChapter });
    return;
  }

  const { pageCount } = currentChapter;
  const t = setTimeout(() => {
    clearTimeout(t);
    updateInfo();
    updateChapter(pageCount === currentChapter.pageCount ? count + 1 : 0);
  }, 15);
};

const extractHtml = (dom) => {
  const { head, body } = dom;
  head.querySelectorAll('style').forEach((style) => {
    body.append(style);
  });
  body.querySelectorAll('script').forEach((script) => {
    script.parentElement.removeChild(script);
  });
  return body.innerHTML;
};

const openChapter = async (path) => {
  window.history.replaceState(null, '', '/');
  const dom = await downloadChapter(path);
  window.dom = dom;

  window.history.replaceState(null, '', path);
  const { content } = elements;
  content.innerHTML = extractHtml(dom);
  content.setAttribute('style', '');

  Object.assign(currentChapter, {
    path,
    pageIndex: 0,
    pageCount: 0,
  });

  console.time('updateInfo');
  updateChapter();
};

const updateTheme = (css) => {
  elements.theme.innerHTML = css;
};

window.goPage = goPage;
window.openChapter = openChapter;
window.currentChapter = currentChapter;
window.updateTheme = updateTheme;

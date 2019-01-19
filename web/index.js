const MESSAGE = 'EPUB';
const GAP_WIDTH = 20;
const elements = {};
const currentChapter = {
  path: null,
  pageIndex: 0,
  pageCount: 0,
  pageWidth: 0,
  contentWidth: 0,
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
  if (pageIndex < 0 || (pageIndex > 0 && pageIndex >= currentChapter.pageCount)) {
    return '';
  }

  const { content } = elements;
  currentChapter.pageIndex = pageIndex;
  content.setAttribute('style', `${buildOffset()}; visibility: visible`);
  return pageIndex.toString();
};

const onLoadedChapter = () => {
  const { callHandler } = window.flutter_inappbrowser || {};
  console.log(onLoadedChapter, JSON.stringify(currentChapter));

  if (callHandler) {
    callHandler(MESSAGE, { type: 'CHAPTER_LOADED', currentChapter });
  } else {
    goPage();
  }
};

const updateChapter = (count) => {
  if (count > 3) {
    window.history.replaceState(null, '', '/');
    console.timeEnd('updateInfo');
    onLoadedChapter();
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

let inject = () =>
  Emotion.injectGlobal(`
@font-face {
  font-family: HelveticaNowDisplay;
  src: url("/webfonts/regular.woff2"),
    url("/webfonts/regular.woff");
  font-style: normal;
  font-weight: 400;
  font-display: swap;
}
@font-face {
  font-family: HelveticaNowDisplay;
  src: url("/webfonts/bold.woff2"),
    url("/webfonts/bold.woff");
  font-style: normal;
  font-weight: 700;
  font-display: swap;
}

:root {
  --main-background-color: #F4F7F8;
  --main-text-color: #31383E;
  --main-accented-background-color: #FFF;
  --main-contrast-color: rgba(0, 0, 0, 0.8);
  --main-contrast-background-color: rgba(0, 0, 0, 0.05);
  --main-contrast-accented-background-color: rgba(0, 0, 0, 0.12);
  --main-link-color: #9146ff;
}

@media(prefers-color-scheme: dark) {
  :root {
   --main-background-color: #222;
   --main-text-color: #fff;
   --main-accented-background-color: #444;
   --main-contrast-color: rgba(255, 255, 255, 0.6);
   --main-contrast-background-color: rgba(255, 255, 255, 0.05);
   --main-contrast-accented-background-color: rgba(255, 255, 255, 0.124);
   --main-link-color: #FF46F7;
  }
}

html {
  padding: 0;
  margin: 0;
  height: -webkit-fill-available;
  font-family: HelveticaNowDisplay, "Helvetica Neue", Helvetica, Arial, sans-serif;
  background-color: var(--main-background-color);
  color: var(--main-text-color);
}


body {
  padding: 0; 
  margin: 0;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  min-height: -webkit-fill-available;
}
#root {
  display: flex;
  flex-direction: column;
  flex-grow: 1
}

a {
  color: var(--main-link-color);
}

a:hover {
  text-decoration: none;
}

input, select, textarea, button, a, [role="button"] {-webkit-tap-highlight-color: rgba(0, 0, 0, 0); }
`)

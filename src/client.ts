import './styles.css';
import { app } from 'hyperapp';
import { onUrlChange, onUrlRequest, pushUrl } from '@shish2k/hyperapp-navigation';
import App from './app';

export type State = {
  url: {
    pathname: string,
  },
};

// TODO: use when we can import builtins.
// import logger from './logger';
// logger.debug('Initializing');

app({
  init: {
    url: window.location,
  } as State,
  subscriptions: state => [
    onUrlChange((state, url) => ({ ...state, url: url })),
    onUrlRequest((state, location) => {
      pushUrl(location.pathname);
      return [state];
    }),
  ],
  view: App,
  node: document.getElementById('app')!,
});

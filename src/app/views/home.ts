import { h, text } from 'hyperapp'
import type { State } from '../../client';

export default (state: State) => h('div', {}, [
  h('h1', {}, text('Hello, world')),
]);

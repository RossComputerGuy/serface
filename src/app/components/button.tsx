import h from 'hyperapp-jsx-pragma';
import type { State } from '../../client';

export default (props: object, children: array) => (
  <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
    {children}
  </button>
);

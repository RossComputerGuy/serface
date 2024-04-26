import copy from 'rollup-plugin-copy-enhanced';
import builtins from 'rollup-plugin-node-builtins';
import globals from 'rollup-plugin-node-globals';
import { babel } from '@rollup/plugin-babel';
import postcss from 'rollup-plugin-postcss';
import tailwind from 'tailwindcss';
import { defineBuildConfig } from 'unbuild';
import { isDev, env } from './src/config';

export default defineBuildConfig([
  {
    entries: ['./src/server', 'bin/serve'],
    declaration: true,
    sourcemap: isDev,
    rollup: {
      inlineDependencies: true,
      allowSyntheticDefaultImports: true,
      replace: {
        'process.env.IS_SSR': '"true"',
      },
      esbuild: {
        minify: true,
      },
      emitCJS: true,
    },
  },
  // FIXME: figure out why require() is being used on the web
  {
    entries: ['./src/client'],
    declaration: true,
    sourcemap: isDev,
    rollup: {
      inlineDependencies: true,
      allowSyntheticDefaultImports: true,
      output: {
        inlineDynamicImports: true,
      },
      replace: {
        'process.env.NODE_ENV': `"${env}"`,
        'process.env.IS_SSR': '"false"',
      },
      resolve: {
        browser: true,
        main: true,
        preferBuiltins: false,
      },
      commonjs: {
        transformMixedEsModules: true,
        include: 'node_modules/**',
      },
      esbuild: {
        minify: true,
      },
    },
    hooks: {
      'rollup:options'(_, options) {
        options.plugins = [
          copy([
            'src/static/**/*',
            'src/views/**/*.ejs',
          ], {
            minify: true,
          }),
          postcss({
            extract: 'styles.css',
            plugins: [
              tailwind(),
            ],
          }),
          globals(),
          builtins(),
          ...options.plugins,
          babel({ babelHelpers: 'bundled' }),
        ];
      },
    },
  },
]);

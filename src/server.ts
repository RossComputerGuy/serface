import { getPort } from 'get-port-please';
import { dirname, join } from 'path';
import { renderToString } from 'hyperapp-render';
import express from 'express';
import { fileURLToPath } from 'url';
import logger from './logger';
import { isDev } from './config';
import { routes } from './app';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();

app.set('views', join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use((req, _, next) => {
  logger.debug(`Received connection to ${req.path} from ${req.ip} (UA: ${req.headers['user-agent']})`);
  next();
});

if (isDev) app.use('/client.mjs.map', express.static(join(__dirname, 'client.mjs.map')));
app.use('/index.js', express.static(join(__dirname, 'client.mjs')));
app.use('/styles.css', express.static(join(__dirname, 'styles.css')));
app.use(express.static(join(__dirname, 'static')));

app.use((req, res) => {
  const view = routes[req.path] ?? routes['404'];
  const status = req.path in routes ? 200 : 404;
  res.status(status).render('index', {
    rendered: renderToString(view({
      url: {
        pathname: req.path,
      },
    })),
  });
});

getPort({
  random: true,
  portRange: [1000, 8000],
}).then((port) => {
  app.listen(port, () => {
    logger.info(`Server is now listening at http://localhost:${port}`);
  });
}).catch(err => {
  logger.error(`Failed to initialize server: ${err}`);
});

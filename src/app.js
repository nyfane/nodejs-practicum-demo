const express = require('express');

const app = express();

app.disable('x-powered-by');

app.get('/', (_request, response) => {
  response.json({
    message: 'Welcome to my practicum application'
  });
});

app.get('/health', (_request, response) => {
  response.json({
    status: 'ok',
    version: process.env.APP_VERSION || 'local'
  });
});

app.use((_request, response) => {
  response.status(404).json({
    error: 'Not found'
  });
});

module.exports = app;
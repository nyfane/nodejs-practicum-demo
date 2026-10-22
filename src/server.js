const app = require('./app');

const port = Number(process.env.PORT || 3000);

const server = app.listen(port, '0.0.0.0', () => {
  console.log(`Application running on port ${port}`);
});

process.on('SIGTERM', () => {
  server.close();
});

process.on('SIGINT', () => {
  server.close();
});


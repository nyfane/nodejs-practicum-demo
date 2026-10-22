const request = require('supertest');
const app = require('../src/app');

describe('Practicum application', () => {
  test('GET / returns the welcome message', async () => {
    const response = await request(app).get('/');

    expect(response.status).toBe(200);
    expect(response.body.message).toBe(
      'Welcome to my practicum application'
    );
  });

  test('GET /health returns a healthy status and version', async () => {
    const response = await request(app).get('/health');

    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ok');
    expect(typeof response.body.version).toBe('string');
    expect(response.body.version.length).toBeGreaterThan(0);
  });

  test('An unknown route returns 404', async () => {
    const response = await request(app).get('/missing');

    expect(response.status).toBe(404);
    expect(response.body.error).toBe('Not found');
  });
});
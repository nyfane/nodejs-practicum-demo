# nodejs-practicum-demo
Sample Node.js application for a practicum CI/CD exercise.

## Project purpose

Sample Node.js application demonstrating CI/CD with GitHub Actions,
Docker, and a Kubernetes test environment.

## Application

- `/` returns a welcome message.
- `/health` returns the application status and release version.
- Unknown routes return HTTP 404.

## CI/CD workflow

On pull requests targeting main, GitHub Actions:

1. Installs dependencies using npm ci.
2. Runs ESLint and Jest tests with coverage on Node.js 22 and 24.
3. Audits production dependencies, failing on high or critical findings.
4. Builds a Docker image and checks the running container.
5. Creates a temporary kind Kubernetes cluster.
6. Deploys the application into the test namespace.
7. Verifies application health and the expected commit version.
8. Exercises rollback using an intentionally failing readiness check.
9. Deletes the temporary cluster.

After a merge into main, the workflow also publishes a commit-tagged
Docker image to GitHub Container Registry.

## Run locally

```bash
npm ci
npm run lint
npm test
npm start
```

## Kubernetes files and scripts

- k8s/namespace.yml: creates the test namespace.
- k8s/deployment.yml: defines the application, health probes, and resources.
- k8s/service.yml: provides access inside the cluster.
- scripts/deploy.sh: deploys a selected image.
- scripts/smoke-test.sh: checks application health and release version.
- scripts/rollback.sh: restores a specified deployment revision.

## Rollback exercise

The workflow first verifies a healthy deployment and records its revision.
It then introduces an incorrect readiness-check path. When the rollout
fails, it restores the recorded revision and verifies recovery.

This is a controlled recovery exercise. A first deployment has no earlier
release to restore.

## Scope and limitations

- The GitHub Actions cluster exists only during the workflow run.
- The pipeline does not deploy to the Kubernetes cluster on my laptop.
- The application has no permanent public URL.
- Publishing currently rebuilds the image in a separate job. A future
  improvement is to promote the exact tested image by digest.
- A development dependency audit finding was observed in the Jest
  dependency chain. The production-only audit reported no findings
  during local setup; development dependency remediation remains open.
- The sample has no database. Database recovery would require a separate plan.

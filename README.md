# Prismatic Component Publisher

This GitHub Action publishes a component via Prismatic's Prism CLI.

## Inputs

- **PRISMATIC_URL** (required): The target Prismatic API to publish to.
- **PRISM_REFRESH_TOKEN** (required): The token granting access to the API at the PRISMATIC_URL provided.
- **CUSTOMER_ID** (optional): The ID of the customer with which to associate the component.
- **COMMENT** (optional): Any comments to associate with the component.
- **SKIP_COMMIT_HASH_PUBLISH** (optional): Skip inclusion of commit hash in metadata. Default is `false`.
- **SKIP_COMMIT_URL_PUBLISH** (optional): Skip inclusion of commit URL in metadata. Default is `false`.
- **SKIP_REPO_URL_PUBLISH** (optional): Skip inclusion of repository URL in metadata. Default is `false`.
- **SKIP_PULL_REQUEST_URL_PUBLISH** (optional): Skip inclusion of pull request URL in metadata. Default is `false`.

## Example Usage

To use this action in your workflow, add the following step configuration to your workflow file (this assumes that `PRISMATIC_URL` is stored in a Github environment's `variables` and that `PRISM_REFRESH_TOKEN` is stored in the same environment's `secrets`):

```yaml
  - name: <STEP NAME>
    uses: prismatic-io/component-publisher@v1
    with:
      PRISMATIC_URL: ${{ vars.PRISMATIC_URL }}
      PRISM_REFRESH_TOKEN: ${{ secrets.PRISM_REFRESH_TOKEN }}
```
Optional inputs can be passed via the `with` block as desired. 

## Acquiring PRISM_REFRESH_TOKEN

To acquire a refresh token that will authenticate against the Prism CLI, run this command in a terminal (assuming you are authenticated with the CLI):
```
prism me:token --type=refresh
```
This will produce a token valid for the Prismatic stack that your CLI is currently configured to. To check which API Prism is currently configured for, run:
```
prism me
```

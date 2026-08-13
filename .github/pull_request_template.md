# Description
New tool, Bug fixing, or Improvement?
Please include a summary of the change and which issue is fixed. Also include relevant motivation and context.
**For new tools, please provide total size and installation time.**

<!-- Currently, we can't accept external contributions to macOS source. Please find more details in [CONTRIBUTING.md](CONTRIBUTING.md#macOS) guide -->

#### Related issue:

## Check list
- [ ] Related issue / work item is attached
- [ ] Tests are written (if applicable)
- [ ] Documentation is updated (if applicable)
- [ ] Changes are tested and related VM images are successfully generated
name: Validate JSON Schema

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

permissions:
  contents: read

jobs:
  validate-json-schema:
    name: Validate JSON files
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v5

      - name: Setup Node.js
        uses: actions/setup-node@v5
        with:
          node-version: 22

      - name: Validate JSON files
        shell: bash
        run: |
          set -e

          echo "🔎 Buscando archivos JSON..."

          files=$(find . \
            -type f \
            -name "*.json" \
            -not -path "./.git/*" \
            -not -path "./node_modules/*")

          if [ -z "$files" ]; then
            echo "ℹ️ No se encontraron archivos JSON."
            exit 0
          fi

          failed=0

          while IFS= read -r file; do
            echo "Validando: $file"

            if node -e "JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'))" "$file"; then
              echo "✅ JSON válido: $file"
            else
              echo "JSON válido: $file"
              failed=1
            fi
          done <<< "$files"

          if [ "$failed" -ne 0 ]; then
            echo "Se encontraron archivos JSON válidos."
            exit 1
          fi

          echo "✅ Todos los archivos JSON son válidos."

      - name: Generate validation report
        shell: bash
        run: |
          cat > report-final.md <<'EOF'
          # JSON Validation Report

          ## Status

          ✅ JSON validation completed successfully.

          ## Security

          This workflow only validates JSON files.

          It does NOT:

          - transfer cryptocurrency
          - access private keys
          - access seed phrases
          - sign blockchain transactions
          - move USDT
          - move TRX
          - access wallet funds
          EOF

          echo "📄 Reporte creado: report-final.md"

      - name: Upload validation report
        uses: actions/upload-artifact@v4
        with:
          name: json-validation-report
          path: report-final.md

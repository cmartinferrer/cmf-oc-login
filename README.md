# Secure OpenShift Login Script

This script automates login to an OpenShift server using `curl` and `oc login`.

## Usage

1. Create a `.env` file by copying the example:

```bash
cp .env.example .env
```

2. Edit `.env` with your real credentials (never commit this file).

3. Make the script executable and run it:

```bash
chmod +x login.sh
./login.sh
```

## Security

- Sensitive information is stored in `.env`, which is **gitignored**.
- Never include secrets directly in the script.

## Requirements

- `curl`, `grep`, `sed`, and `oc` (OpenShift CLI) must be installed.

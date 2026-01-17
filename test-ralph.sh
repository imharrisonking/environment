#!/bin/bash
set -e

# Setup test directory
TEST_DIR="/tmp/ralph-test-$(date +%s)"
echo "Setting up test environment in $TEST_DIR..."
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Initialize git (Ralph needs it)
git init
git config user.email "test@example.com"
git config user.name "Test User"
git checkout -b main

# Create a dummy project structure
echo "console.log('Hello World');" > index.js
echo "# Test Project" > README.md
git add .
git commit -m "Initial commit"

# Setup Ralph files
mkdir -p scripts/ralph
# Copy from source location (adjust if needed)
cp /home/hking/environment/home/.config/opencode/ralph/ralph.sh scripts/ralph/
cp /home/hking/environment/home/.config/opencode/ralph/prompt.md scripts/ralph/
chmod +x scripts/ralph/ralph.sh

# Create a simple PRD
cat > scripts/ralph/prd.json <<EOF
{
  "project": "Test Project",
  "branchName": "ralph/test-feature",
  "description": "A test feature to verify Ralph works",
  "userStories": [
    {
      "id": "US-001",
      "title": "Create a hello world file",
      "description": "Create a file named hello.txt with content 'Hello Ralph'",
      "acceptanceCriteria": [
        "File hello.txt exists",
        "Content is 'Hello Ralph'",
        "Typecheck passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
EOF

# Create dummy progress file
touch scripts/ralph/progress.txt

echo "Test environment ready."
echo "Running Ralph for 1 iteration..."
echo "Command: ./scripts/ralph/ralph.sh 1"

# We run it here
./scripts/ralph/ralph.sh 1

echo "---------------------------------------------------"
echo "Test complete. Check $TEST_DIR for results."
echo "To clean up: rm -rf $TEST_DIR"

#!/usr/bin/env bash
set -e

# Ralph Loop Script for OpenCode CLI
# Main loop for planning and building

# Default values
MODE=""
WORK_SCOPE=""
MAX_ITERATIONS=10
ITERATION=0

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 [plan|build|plan-work] [max_iterations|work_description]"
    echo "Examples:"
    echo "  $0 plan 10           # Plan mode with max 10 iterations"
    echo "  $0 build 20          # Build mode with max 20 iterations"
    echo "  $0 plan-work \"Implement user auth\"  # Plan specific work"
    exit 1
fi

MODE="$1"
shift

# Determine prompt file and handle additional arguments
case "$MODE" in
    plan)
        PROMPT_FILE="$SCRIPT_DIR/PROMPT_plan.md"
        if [ $# -gt 0 ]; then
            MAX_ITERATIONS="$1"
        fi
        ;;
    build)
        PROMPT_FILE="$SCRIPT_DIR/PROMPT_build.md"
        if [ $# -gt 0 ]; then
            MAX_ITERATIONS="$1"
        fi
        ;;
    plan-work)
        PROMPT_FILE="$SCRIPT_DIR/PROMPT_plan_work.md"
        if [ $# -eq 0 ]; then
            echo "Error: plan-work mode requires a work description"
            echo "Usage: $0 plan-work \"work description\" [max_iterations]"
            exit 1
        fi
        WORK_SCOPE="$1"
        if [ $# -gt 1 ]; then
            MAX_ITERATIONS="$2"
        fi
        ;;
    *)
        echo "Error: Unknown mode '$MODE'"
        echo "Valid modes: plan, build, plan-work"
        exit 1
        ;;
esac

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Validate mode-specific requirements
if [ "$MODE" == "plan-work" ]; then
    if [ "$CURRENT_BRANCH" == "main" ] || [ "$CURRENT_BRANCH" == "master" ]; then
        echo "Error: plan-work mode cannot be used on main or master branch"
        echo "Current branch: $CURRENT_BRANCH"
        echo "Please create a feature branch first"
        exit 1
    fi
fi

# Validate prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "Error: Prompt file not found: $PROMPT_FILE"
    exit 1
fi

# Print configuration
echo "========================================"
echo "Ralph Loop - OpenCode CLI"
echo "========================================"
echo "Mode:        $MODE"
echo "Prompt file: $PROMPT_FILE"
echo "Branch:      $CURRENT_BRANCH"
echo "Max iterations: $MAX_ITERATIONS"
if [ ! -z "$WORK_SCOPE" ]; then
    echo "Work scope:  $WORK_SCOPE"
fi
echo "========================================"
echo ""

# Main loop
while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    echo "========================================"
    echo "Iteration $((ITERATION + 1)) / $MAX_ITERATIONS"
    echo "========================================"
    echo ""

    # Prepare prompt (substitute work scope if needed)
    if [ ! -z "$WORK_SCOPE" ]; then
        CURRENT_PROMPT=$(sed "s/\${WORK_SCOPE}/$WORK_SCOPE/g" "$PROMPT_FILE")
    else
        CURRENT_PROMPT=$(cat "$PROMPT_FILE")
    fi

    # Run OpenCode CLI
    echo "Running OpenCode CLI..."
    opencode run --agent ralph --model github-copilot/claude-sonnet-4.5 "$CURRENT_PROMPT"

    # Check exit code
    if [ $? -ne 0 ]; then
        echo "Warning: OpenCode CLI exited with non-zero status"
        echo "Continuing anyway..."
    fi

    echo ""

    # Git push after iteration
    echo "Pushing changes to $CURRENT_BRANCH..."
    if ! git push origin "$CURRENT_BRANCH" 2>/dev/null; then
        echo "Remote branch doesn't exist, creating..."
        git push -u origin "$CURRENT_BRANCH"
    fi

    # Increment iteration counter
    ITERATION=$((ITERATION + 1))

    # Print separator between iterations
    echo ""
    echo "========================================"
    echo "Completed iteration $ITERATION"
    echo "========================================"
    echo ""

    # Small pause between iterations
    sleep 1
done

echo "========================================"
echo "Loop completed after $MAX_ITERATIONS iterations"
echo "========================================"

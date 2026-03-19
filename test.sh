#!/bin/bash

echo "🧪 Running PomoGlass Unit Tests..."
echo ""

swift test

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All tests passed!"
else
    echo ""
    echo "❌ Some tests failed."
    exit 1
fi

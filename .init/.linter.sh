#!/bin/bash
cd /home/kavia/workspace/code-generation/tic-tac-toe-web-interface-176345-176374/tictactoe_frontend
npm run lint
ESLINT_EXIT_CODE=$?
npm run build
BUILD_EXIT_CODE=$?
if [ $ESLINT_EXIT_CODE -ne 0 ] || [ $BUILD_EXIT_CODE -ne 0 ]; then
   exit 1
fi


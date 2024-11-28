#!/bin/bash

stack dot --external > frontend/dot.txt
git log | head -n1000 > frontend/log.txt

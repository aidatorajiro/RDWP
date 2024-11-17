#!/bin/bash

stack dot --external > frontend/dot.txt
git log > frontend/log.txt
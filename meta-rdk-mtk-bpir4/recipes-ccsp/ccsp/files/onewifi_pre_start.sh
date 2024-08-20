#!/bin/sh

iw phy phy0 interface add wifi0 type __ap
iw phy phy1 interface add wifi1 type __ap

exit 0

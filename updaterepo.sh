#!/bin/bash
dnf install -y createrepo

createrepo --update /repo/BaseOS
createrepo --update /repo/AppStream

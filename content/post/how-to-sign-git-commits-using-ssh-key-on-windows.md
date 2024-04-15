---
title: How to sign Git commits using SSH key on Windows
description: Sign your Git commits using SSH key instead of GPG key
date: 2024-04-15T21:24:00+08:00
tags:
  - GitHub
  - Windows
  - dev
  - tutorials
---
Since GitHub started supporting GitHub SSH commit verification in 2022,[^1] I started using my SSH key in 2023 to sign my Git commits. Why? Because, I think managing my GPG keys is too complicated, and I don't need GPG's web of trust, since no one wanted to perform a [key signing party](https://en.wikipedia.org/wiki/Key_signing_party) with me. So in 2023, I started winding down the usage of my GPG key, and started transitioning to my SSH key for signing my Git commits.

## Generate or convert your SSH key to OpenSSH format

If you don't have an SSH key today, you can start generating one. If you wanted to, you can use [vanityssh-go](https://github.com/danielewood/vanityssh-go) to create an SSH key with a vanity fingerprint, just like me.

If your SSH key is in PuTTY format, you can open it using PuTTYgen, and export it to OpenSSH key.

If your SSH key is already in OpenSSH format, you can proceed.

## Placing your SSH key to proper location

1. Put your SSH private key to `%UserProfile%\.ssh` folder. The SSH private key should not have a file extension. For this example, my SSH private key has a filename `id_ed25519`.
2. If you have a .pub file, put your private key to `%UserProfile%\.ssh` folder. It must have the same filename as the SSH private key but with the .pub extension.
   1. If you don't have a .pub file, open the key using PuTTYgen, and copy the whole text inside "Public key for pasting into OpenSSH authorized_keys file" and create a text file, paste the public key inside it, and save it with the same filename as your private key but with the .pub extension. For this example, my SSH public key has a filename `id_ed25519.pub`.

## Telling Git to use your SSH key to sign commits

1. Configure Git to use SSH to sign commits and tags.\
`git config --global gpg.format ssh`
2. Set your SSH signing key in Git with the path to the public key. For this example, the location of the key is in `%UserProfile%\.ssh`.\
`git config --global user.signingkey "C:\\Users\\<username>\\.ssh\\id_ed25519.pub"`
3. Configure Git to always sign commits.\
`git config --global commit.gpgsign true`
4. Configure Git to always sign tags.\
`git config --global tag.gpgsign true`

Now every time you commit, it will automatically sign using your SSH key. If your SSH key has a passphrase, it will ask for the passphrase for every commit.

[^1]: [SSH commit verification now supported](https://github.blog/changelog/2022-08-23-ssh-commit-verification-now-supported/)
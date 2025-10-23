#!/bin/bash
#
pnpm create next-app@latest $1 --yes
cd $1
pnpm dlx shadcn@latest init
pnpm dlx shadcn@latest add dashboard-01
pnpm dlx shadcn@latest add login-01
pnpm dlx shadcn@latest add signup-01
pnpm dlx shadcn@latest add @ai-elements/all

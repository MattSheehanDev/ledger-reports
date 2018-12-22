#!/bin/bash

ledger bal "^Assets:Portfolio:Paychex:401k" --pivot TYPE --limit "tag(\"TYPE\")"

ledger reg "^Assets:Portfolio:Paychex:401k" --limit "tag(\"TYPE\")=='TRADITIONAL'"

ledger reg "^Assets:Portfolio:Paychex:401k" --limit "tag(\"TYPE\")=='MATCH'"


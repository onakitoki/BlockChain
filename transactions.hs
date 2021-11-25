module Transactions where

import Types

clientesBlockchain :: [Peer]
clientesBlockchain = [
    Peer "Jaime" "1.1.1.1" (Wallet 1000),
    Peer "Alejandro" "1.1.1.2" (Wallet 500),
    Peer "Alvaro" "1.1.1.3" (Wallet 250),
    Peer "Gustavo" "1.1.1.4" (Wallet 115.0),
    Peer "Pepe" "1.1.1.5" (Wallet 70.0),
    Peer "Antonio" "1.1.1.6" (Wallet 100.0)]

transacciones :: [Transaction]
transacciones = [
    Transaction "1.1.1.1" "1.1.1.2" 50 False,
    Transaction "1.1.1.1" "1.1.1.3" 125 False,
    Transaction "1.1.1.3" "1.1.1.6" 2 False,
    Transaction "1.1.1.4" "1.1.1.5" 32 False,
    Transaction "1.1.1.2" "1.1.1.1" 21 False,
    Transaction "1.1.1.4" "1.1.1.3" 1520 False,
    Transaction "1.1.1.6" "1.1.1.3" 58 False,
    Transaction "1.1.1.5" "1.1.1.4" 179 False]
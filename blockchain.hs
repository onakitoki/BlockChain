{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE GADTs               #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies        #-}


import Types
import BlockFunctions
import Data.Time ( getCurrentTime )
import Transactions
import Types (Wallet(amount_wallet, Wallet), Chain (peers))
import Transactions (clientesBlockchain)

addBlockToChain :: Block -> Chain -> Chain
addBlockToChain block chain | isValidBlock block (last (chain_block chain)) =
    chain {chain_block = block:chain_block chain}
                            | otherwise = chain

recompensa :: Double
recompensa = 100

peerMine :: Peer -> Block -> Chain -> IO (Peer, Block)
peerMine peer block chain =
    do

        let transactions = dataBlock block
        let datos = [ (sender x, receiver x, amount x) | x<-transactions]

        mined_block <- mineBlock block
        let money = amount_wallet (wallet peer)
        return (peer {wallet = Wallet (money+recompensa) }, mined_block)

main :: IO ()
main =
    do
        --Creamos Clientes, Transacciones, BlockChain y Bloque Genesis
        let peers = clientesBlockchain
        let transactions = transacciones
        let blockchain = Chain transactions peers []
        genesis_block <- createGenesisBlock

        -- Añadimos el bloque genesis a la cadena
        let chain0 = blockchain {chain_block=genesis_block:chain_block blockchain}

        -- A partir de ahi vamos generando nuevos bloques dependiendo de las transacciones que se
        -- acumulen y los mineros se encargan de minarlos y añadirlos a la cadena

        block1 <- generateNextBlock (last (chain_block chain0)) transactions
        minedBlock1 <- mineBlock block1
        let chain = addBlockToChain minedBlock1 chain0

        putStrLn $ "Generando Bloque Genesis: ---- " ++ show genesis_block
        putStrLn $ "Añadiendo Bloque a la cadena: ---- " ++ show chain0
        putStrLn $ "Generando siguiente Bloque: ---- " ++ show block1
        putStrLn $ "Minando Bloque --------- " ++ show minedBlock1
        putStrLn $ "Nueva Cadena --------- " ++ show chain




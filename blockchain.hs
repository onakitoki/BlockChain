{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE GADTs               #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies        #-}

import Control.Concurrent
import Types
import BlockFunctions
import Transactions
import Data.Time ( getCurrentTime )

addBlockToChain :: Block -> Chain -> Chain
addBlockToChain block chain | isValidBlock block (last (chain_block chain)) =
    chain {chain_block = block:chain_block chain}
                            | otherwise = chain

recompensa :: Double
recompensa = 100

peerMine :: Peer -> Block -> Chain -> IO Chain
peerMine peer block chain =
    do
        let recompensa = 200
        mined_block <- mineBlock block
        let previous_block = last (chain_block chain)
        if isValidBlock mined_block previous_block then
            let new_peer = peer {wallet = wallet peer + recompensa } in
                return chain {peers = rep (peers chain) peer new_peer,
                    chain_block = chain_block chain ++ [mined_block]}
            else
                return chain


main :: IO ()
main =
    do
        --Creamos Clientes, Transacciones, BlockChain y Bloque Genesis
        let peersZero = clientesBlockchain
        let transactions = transacciones
        let blockchain = Chain transactions peersZero []
        genesis_block <- createGenesisBlock

        -- Añadimos el bloque genesis a la cadena
        let chain0 = blockchain {chain_block=genesis_block:chain_block blockchain}

        -- A partir de ahi vamos generando nuevos bloques dependiendo de las transacciones que se
        -- acumulen y los mineros se encargan de minarlos y añadirlos a la cadena

        block1 <- generateNextBlock (last (chain_block chain0)) transactions


        let jaime = head peersZero


        chain <- peerMine jaime block1 chain0


        putStrLn $ "Generando Bloque Genesis: ---- " ++ show genesis_block
        threadDelay 5000000
        putStrLn $ "Añadiendo Bloque a la cadena: ---- " ++ show chain0
        threadDelay 5000000
        putStrLn $ "Generando siguiente Bloque: ---- " ++ show block1
        threadDelay 5000000

        putStrLn $ show jaime ++ " esta minando el bloque : -----" ++ show chain

        print $ filter (==jaime) (peers chain)
        --putStrLn $ "Minando Bloque --------- " ++ show minedBlock1
        --threadDelay 5000000
        --putStrLn $ "Nueva Cadena --------- " ++ show chain




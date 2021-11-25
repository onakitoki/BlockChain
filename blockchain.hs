{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE GADTs               #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies        #-}


import Types
import BlockFunctions
import Data.Time ( getCurrentTime )
import Transactions

addBlockToChain :: Block -> Chain -> Chain
addBlockToChain block chain | isValidBlock block (last (chain_block chain)) =
    chain {chain_block = block:chain_block chain}
                            | otherwise = chain

main :: IO ()
main =
    do
        --Creamos la Cadena Inicial, y el Bloque Genesis
        let blockchain = Chain [] []
        genesis_block <- createGenesisBlock

        -- Añadimos el bloque genesis a la cadena
        let chain0 = blockchain {chain_block=genesis_block:chain_block blockchain}

        -- A partir de ahi vamos generando nuevos bloques dependiendo de las transacciones que se
        -- acumulen y los mineros se encargan de minarlos y añadirlos a la cadena

        block1 <- generateNextBlock $ last (chain_block chain0)
        minedBlock1 <- mineBlock block1
        let chain = addBlockToChain minedBlock1 chain0

        putStrLn $ "Generando Bloque Genesis: ---- " ++ show genesis_block
        putStrLn $ "Añadiendo Bloque a la cadena: ---- " ++ show chain0
        putStrLn $ "Generando siguiente Bloque: ---- " ++ show block1
        putStrLn $ "Minando Bloque --------- " ++ show minedBlock1
        putStrLn $ "Nueva Cadena --------- " ++ show chain




{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE GADTs               #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies        #-}


import Data.Time ( getCurrentTime )
import Crypto.Hash.SHA256 as SHA256 ( hash )
import qualified Data.ByteString.Char8
import Text.Hex ( encodeHex, Text )
import Types
import qualified Data.Text (unpack)




blockToString :: Block -> String
blockToString (Block i d t p n h) = concat [show i, d, show t, p, show n, h]


hashBlock :: String -> String
hashBlock blockString =
    Data.Text.unpack $ encodeHex $ SHA256.hash $ Data.ByteString.Char8.pack blockString

setHashNonce :: Block -> Block
setHashNonce block = block {nonce = fst (proofOfWork block), Types.hash = snd (proofOfWork block)}

-- Difficulty set to 4 digits.

hashSatisfies :: [Char] -> Bool
hashSatisfies hash  | take 4 hash == "0000" = True
                    | otherwise = False


-- Proof of Work
proofOfWork :: Block -> (Integer, String)
proofOfWork block    | hashSatisfies hash = (nonce block, hash)
                    | otherwise = proofOfWork block {nonce = nonce_block + 1}
                    where
                        hash = hashBlock $ blockToString block
                        nonce_block = nonce block


createGenesisBlock :: IO Block
createGenesisBlock =
                    do
                        clock <- getCurrentTime
                        let genesis_block = Block 0 "" clock "0" 0 ""
                        return $ setHashNonce genesis_block

generateNextBlock :: Block -> IO Block
generateNextBlock block =
    do
        clock <- getCurrentTime
        return block
                    {Types.index = Types.index block +1,
                    dataBlock = "",
                    timestamp = clock,
                    previous_hash = Types.hash block,
                    nonce = 0,
                    Types.hash = ""}

mineBlock :: Block -> Block
mineBlock = setHashNonce

isValidBlock :: Block -> Block -> Bool
isValidBlock block previous | Types.index block /= Types.index previous + 1 = False
                            | Types.hash previous /= previous_hash block = False
                            | not $ hashSatisfies $ Types.hash block = False
                            | otherwise = True

returnBlockToChain :: Block -> Chain -> Chain
returnBlockToChain block chain = chain {Types.chain = block : Types.chain chain}

main :: IO ()
main =
    do
        let blockchain = Chain "Data" []
        genesis_block <- createGenesisBlock
        let chain1 = returnBlockToChain genesis_block blockchain

        block1 <- generateNextBlock $ last (chain chain1)

        let minedBlock1 = mineBlock block1

        putStrLn $ "Generando Bloque Genesis: ---- " ++ show genesis_block
        putStrLn $ "Añadiendo Bloque a la cadena: ---- " ++ show chain1
        putStrLn $ "Generando siguiente Bloque: ---- " ++ show block1




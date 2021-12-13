module BlockFunctions where

import Types
import Crypto.Hash.SHA256 as SHA256 ( hash )
import qualified Data.ByteString.Char8
import Text.Hex ( encodeHex, Text )
import qualified Data.Text (unpack)
import Data.Time ( getCurrentTime )

-- Función para transformar un bloque en un String
blockToString :: Block -> String
blockToString (Block i d t p n h) = concat [show i, show d, show t, p, show n, h]


-- Dado un String que contiene los datos del bloque, me devuelve un hash
hashBlock :: String -> String
hashBlock blockString =
    Data.Text.unpack $ encodeHex $ SHA256.hash $ Data.ByteString.Char8.pack blockString

-- Funcion para establecer el hash y el nonce de un bloque
setHashNonce :: Block -> IO Block
setHashNonce block =
                    do
                        clock <- getCurrentTime
                        return block {timestamp = clock, nonce = fst (proofOfWork block),
                                      Types.hash = snd (proofOfWork block)}

-- Dificultad 4

difficulty :: Int
difficulty = 4

-- TEST para LISTA COMPRENSION
hashSatisfies :: [Char] -> Bool
hashSatisfies hash = and [ x=='0' | x <- take difficulty hash]


-- Proof of Work. Algoritmo de consenso.
proofOfWork :: Block -> (Integer, String)
proofOfWork block    | hashSatisfies hash = (nonce block, hash)
                    | otherwise = proofOfWork block {nonce = nonce_block + 1 }
                    where
                        hash = hashBlock $ blockToString block
                        nonce_block = nonce block

-- Prueba para validar que los bloques son correctos
isValidBlock :: Block -> Block -> Bool
isValidBlock block previous | Types.index block /= Types.index previous + 1 = False
                            | Types.hash previous /= previous_hash block = False
                            | not $ hashSatisfies $ Types.hash block = False
                            | otherwise = True

-- Función para minar bloques
mineBlock :: Block -> IO Block
mineBlock = do setHashNonce

-- Función para crear el Bloque Génesis
createGenesisBlock :: IO Block
createGenesisBlock =
                    do
                        clock <- getCurrentTime
                        let genesis_trans = []
                        let genesis_block = Block 0 genesis_trans clock "0" 0 ""
                        setHashNonce genesis_block


-- Función para generar bloques a partir del último bloque de la cadena
generateNextBlock :: Block -> [Transaction] -> IO Block
generateNextBlock block transactions =
                                do
                                    clock <- getCurrentTime
                                    return block
                                        {Types.index = Types.index block +1,
                                        dataBlock = transactions,
                                        timestamp = clock,
                                        previous_hash = Types.hash block,
                                        nonce = 0,
                                        Types.hash = ""}


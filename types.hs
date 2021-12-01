module Types where

import Data.Time (UTCTime)

data Block = Block  { index :: Integer
                    , dataBlock :: [Transaction]
                    , timestamp :: UTCTime
                    , previous_hash :: String
                    , nonce :: Integer
                    , hash :: String
                    } deriving (Show, Eq)


data Chain = Chain {
        unconfirmed_transactions :: [Transaction],
        peers :: [Peer],
        chain_block :: [Block]
    } deriving (Show, Eq)

data Transaction = Transaction { sender :: String
                               , receiver :: String
                               , amount :: Integer
                               , added_to_block :: Bool
                               } deriving (Eq)

data Peer = Peer {
    name :: String,
    address :: String,
    wallet :: Double
} deriving ()

instance Eq Peer where
    (Peer a b c) == (Peer d e f) = b == e

instance Show Peer where
   show (Peer n a w) = show n ++ ": " ++ show w

instance Show Transaction where
    show (Transaction s r a ad) = "HaskellTransaction"
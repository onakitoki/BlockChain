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
        chain_block :: [Block]
    } deriving (Show, Eq)

data Transaction = Transaction { sender :: String
                               , receiver :: String
                               , amount :: Integer
                               , added_to_block :: Bool
                               } deriving (Show, Eq)

data Peer = Peer {
    name :: String,
    address :: String,
    wallet :: Double
} deriving (Show, Eq)
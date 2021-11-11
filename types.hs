module Types where

import Data.Time (UTCTime)

data Block = Block  { index :: Integer
                    , dataBlock :: String
                    , timestamp :: UTCTime
                    , previous_hash :: String
                    , nonce :: Integer
                    , hash :: String
                    } deriving (Show, Eq)


data Chain = Chain {
        unconfirmed_transactions :: String,
        chain :: [Block]
    } deriving (Show, Eq)
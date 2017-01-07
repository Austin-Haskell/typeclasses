# hour 2: electric boogaloo

# let's look at some of the stuff from optparse-applicative we want to be familiar with

## Options.Applicative.Builder

Here are some basic argument types we can use: commands and flags.

```haskell
command :: String -> ParserInfo a -> Mod CommandFields a
```

Add a command to a subparser option.

```haskell
flag :: a  -> a -> Mod FlagFields a -> Parser a
--     [1]   [2]         [3]              [4]
```
1. default value
  
2. active value

3. option modifier
  
4. Builder for a flag parser.

A flag that switches from a "default value" to an "active value" when encountered. For a simple boolean value, use switch instead.

```haskell
switch :: Mod FlagFields Bool -> Parser Bool

switch = flag False True
```



subparser :: Mod CommandFields a -> Parser a

Builder for a command parser. The command modifier can be used to specify individual commands.

strArgument :: Mod ArgumentFields String -> Parser String

Builder for a String argument.

argument :: ReadM a -> Mod ArgumentFields a -> Parser a

Builder for an argument parser.


infoOption :: String -> Mod OptionFields (a -> a) -> Parser (a -> a)

An option that always fails and displays a message.

strOption :: Mod OptionFields String -> Parser String

Builder for an option taking a String argument.


## information we can provide about our arguments

short :: HasName f => Char -> Mod f a

Specify a short name for an option.

long :: HasName f => String -> Mod f a

Specify a long name for an option.

metavar :: HasMetavar f => String -> Mod f a

Specify a metavariable for the argument.

Metavariables have no effect on the actual parser, and only serve to specify the symbolic name for an argument to be displayed in the help text.


## Options.Applicative.Extra

execParser :: ParserInfo a -> IO a Source #

Run a program description.

Parse command line arguments. Display help text and exit if any parse error occurs.

## let's start building a sample program

import Options.Applicative

data Opts = Opts
    { optFlag :: !Bool
    , optVal :: !String
    }

main :: IO ()
main = do
    opts <- execParser optsParser
    putStrLn
        (concat ["Hello, ", optVal opts, ", the flag is ", show (optFlag opts)])
  where
    optsParser =
        info
            (helper <*> versionOption <*> programOptions)
            (fullDesc <> progDesc "optparse example" <>
             header
                 "optparse-example - a small example program for optparse-applicative")
    versionOption = infoOption "0.0" (long "version" <> help "Show version")
    programOptions =
        Opts <$> switch (long "some-flag" <> help "Set the flag") <*>
        strOption
            (long "some-value" <> metavar "VALUE" <> value "default" <>
             help "Override default name")

Without arguments, this program outputs Hello, default! The flag is False. If you run this program with the --help argument

-- data Opts = Opts { foo :: Bool, bar :: Bool } deriving Show

-- parseOpts :: Parser Opts
-- parseOpts = Opts <$> switch (long "foo" <> short 'f' <> help "Foo") <*> switch (long "bar" <> short 'b' <> help "Bar")

-- parseInfoCom :: ParserInfo Command
-- parseInfoCom = info parseCommand (progDesc "Give foo.")

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts desc = info (helper <*> opts) $ progDesc desc

-- parseCommand :: Parser Command
-- parseCommand = subparser $
--     command "foo" (parseOpts `withInfo` "Give me a foo")

-- main :: IO ()
-- main = do
--     opts <- execParser parseInfoCom
--     print opts

module Main where

import Options.Applicative

-- import Lib

data Command = Add String String   | 
               Email String String |
               Phone String String |
               Show String  
               deriving (Eq, Show)

parserAdd :: Parser Command
parserAdd = Add <$> strArgument (metavar "FILENAME") <*> strArgument (metavar "PERSON_NAME")

parserEmail :: Parser Command
parserEmail = Email <$> strArgument (metavar "FILENAME") <*> strArgument (metavar "EMAIL_ADDRESS")

parserPhone :: Parser Command
parserPhone = Phone <$> strArgument (metavar "FILENAME") <*> strArgument (metavar "PHONE_NUMBER")

parserShow :: Parser Command
parserShow = Show <$> strArgument (metavar "FILENAME")

parserCommand :: Parser Command
parserCommand = subparser $ 
    command "add" (parserAdd `withInfo` "Add an entry.") <>
    command "email" (parserEmail `withInfo` "Add email address.") <>
    command "phone" (parserPhone `withInfo` "Add phone number.") <>
    command "show" (parserShow `withInfo` "Show record.")

parserInfoCommand :: ParserInfo Command
parserInfoCommand = info parserCommand (progDesc "Manage address book.")

main :: IO ()
main = do
    command <- execParser parserInfoCommand
    print command

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts desc = info (helper <*> opts) $ progDesc desc
-- Bank System --

-- Variables --
local BankData = {}

local function Trim(s)
  return s:match("^%s*(.-)%s*$")
end

-- Functions --
local DataSafeIn = io.open("Data.txt", "r")
if DataSafeIn then
  for line in DataSafeIn:lines() do
    local username, password, money = line:match("([^,]+),([^,]+),([^,]+)")
    if username and password and money then
      BankData[Trim(username)] = {
        Password = Trim(password),
        Money = tonumber(Trim(money)) or 0
      }
    end
  end
  DataSafeIn:close()
end

local function NewSignIn(Username, Password)
  if BankData[Username] then
    print("Username Already Exists!")
    return false
  end
  BankData[Username] = {
    Password = Password,
    Money = 10
  }
  print("Account Created Successfully!")
  return true
end

local function Login(Username, Password)
  local user = BankData[Username]
  return user and user.Password == Password
end

local function GetUser(Username)
  return BankData[Username]
end

local function Choices(Username)
  local User = GetUser(Username)
  if not User then return end

  print("Would You Like To Withdraw (W), Deposit (D), Or Quit?")
  local Answer2 = io.read()

  if Answer2 == "W" then
    print("You Have $" .. User.Money)
    print("How Much Would You Like To Withdraw?")
    local Amount = tonumber(io.read())
    if not Amount or Amount <= 0 then
      print("Invalid amount.")
    elseif Amount > User.Money then
      print("You Can't Withdraw More Than You Have!")
    else
      User.Money = User.Money - Amount
      print("You Withdrew $" .. Amount .. ". You Now Nave $" .. User.Money)
    end

  elseif Answer2 == "D" then
    print("You Have $" .. User.Money)
    print("How Much Would You Like To Deposit?")
    local Amount = tonumber(io.read())
    if not Amount or Amount <= 0 then
      print("Invalid amount.")
    else
      User.Money = User.Money + Amount
      print("You Deposited $" .. Amount .. ". You Now Have $" .. User.Money)
    end
  else
    print("Exiting Transaction Menu.")
  end
end

local function BankController()
  print("Welcome To The Lua Bank!")
  print("Make An Account (M), Log In (L), Or Quit (Any other key):")
  local Answer = io.read()

  if Answer == "M" then
    print("Enter A Username:")
    local Username = io.read()
    print("Enter A Password:")
    local Password = io.read()
    if type(Username) == "string" and type(Password) == "string" and NewSignIn(Username, Password) then
      Choices(Username)
    end

  elseif Answer == "L" then
    print("Enter Your Username:")
    local Username = io.read()
    print("Enter Your Password:")
    local Password = io.read()
    if Login(Username, Password) then
      print("Login Successful!")
      Choices(Username)
    else
      print("Login Failed: Incorrect Username Or Password.")
    end
  else
    print("Goodbye!")
  end
end

-- Run The Bank --
BankController()

-- Save Data --
local DataSafeOut = io.open("Data.txt", "w")
if DataSafeOut then
  for username, data in pairs(BankData) do
    if data and data.Password and data.Money then
      DataSafeOut:write(username .. "," .. data.Password .. "," .. data.Money .. "\n")
    else
      print("Skipped Saving User: " .. username .. " (Missing Data)")
    end
  end
  DataSafeOut:close()
  print("Data Successfully Saved.")
else
  print("Data Save Failed.")
end

# Firewalla Region Blocker

Script to block all possible regions on your Firewalla box.
See `regions.json` for all the possible regions, [except for the US](#United-States).

## Trust

- Read the script before you use it. It is short and not very complicated.
- The script only connects to the endpoint `https://my.firewalla.com/v1/rule/batchCreate`.
- Delete the `.env` file after using the script. The token allows access to your Firewalla app.
- __Never share your TOKEN or BOX ID with anyone, even if you have questions!__

## Usage

1. Login to your box at [my.firewalla.com](my.firewalla.com).
2. Open the developer menu of your browser.
3. Depending on your browser navigate to `Storage -> Local Storage`.
4. See the values of `SELECTED_BOX_ID` and `__TOKEN_KEEP_SECRET__`.
5. Create `.env` in the same location as `run.sh` and paste the __values__..
    ```sh
    BOX="<SELECTED_BOX_ID>"
    TOKEN="<__TOKEN_KEEP_SECRET__>"
    ``` 
6. Run `run.sh`

The script creates `firewalla.log` in which all responses are stored.

## United States

United States cannot be blocked without exceptions because my.firewalla.com API is hosted there.
To block the United States allow the IP address or domain name of my.firewalla.com first.
Use `nslookup my.firewalla.com` to reverse the domain to ip addresses.

## Q&A

Feel free to ask me anything.

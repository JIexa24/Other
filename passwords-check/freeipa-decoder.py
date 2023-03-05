#!/usr/bin/env python3
import base64
import re
import sys
import hashlib
import secrets


def hash_password(password, salt=None, iterations=260000):
    if salt is None:
        salt = secrets.token_hex(16)
    pw_hash = hashlib.pbkdf2_hmac(
        "sha256", password.encode("utf-8"), salt, iterations
    )
    b64_hash = base64.b64encode(
        pw_hash, altchars=b'./').decode('utf-8').rstrip('=')
    salt = base64.b64encode(
        original_salt, altchars=b'./').decode('utf-8').rstrip('=')
    return "{}${}${}${}".format("pbkdf2_sha256", iterations, salt, b64_hash)


def verify_password(password, original_salt, password_hash):
    if (password_hash or "").count("$") != 3:
        return False
    algorithm, iterations, salt, b64_hash = password_hash.split("$", 3)
    iterations = int(iterations)
    compare_hash = hash_password(password, original_salt, iterations)
    # print(f"! {word} {compare_hash} {password_hash}")
    return secrets.compare_digest(password_hash, compare_hash)


next_line = False
user = ''
nt_hash = ''
complete_user = False

for line in sys.stdin:
    line = line.strip()

    m = re.match('^\s+id [0-9]+$', line)
    if m:
        user = ''
        nt_hash = ''

    if not user:
        m = re.match('^\s*uid: (.*)$', line)
        if m:
            user = m.group(1)
            encoded_hash = ''

    # Extract password hash
    m = re.match('userPassword:: ([a-z0-9\+/=]+)', line, re.IGNORECASE)
    if m:
        encoded_hash = m.group(1)
        next_line = True

    # Hash is usually split across multiple lines
    elif next_line == True:
        m = re.match('^\s*([a-z0-9\+/=]+)$', line, re.IGNORECASE)
        if m:
            encoded_hash += m.group(1).strip()
        else:
            next_line = False
            complete_user = True
    original_salt = None
    if complete_user:
        decoded_hash = base64.b64decode(encoded_hash).decode('utf-8')

        if '{PBKDF2_SHA256}' in decoded_hash:
            binary_hash = base64.b64decode(decoded_hash[15:])
            iterations = int.from_bytes(binary_hash[0:4], byteorder='big')

            # John uses a slightly different base64 encodeding, with + replaced by .
            original_salt = binary_hash[4:68]
            salt = base64.b64encode(
                original_salt, altchars=b'./').decode('utf-8').rstrip('=')
            # 389-ds specifies an ouput (dkLen) length of 256 bytes, which is longer than John supports
            # However, we can truncate this to 32 bytes and crack those
            b64_hash = base64.b64encode(
                binary_hash[68:100], altchars=b'./').decode('utf-8').rstrip('=')

            # Formatted for John
            decoded_hash = f"pbkdf2_sha256${iterations}${salt}${b64_hash}"

        wordlist = []
        try:
            with open('wordlist') as f:
                wordlist = f.readlines()
        except FileNotFoundError:
            print(f"File wordlist does not exist.")
            wordlist = ['userpassword']
        except:
            continue
        for word in wordlist + [user]:
            if verify_password(word.strip(), original_salt, decoded_hash):
                print(f'{user}:{word.strip()}')
                break
        # print(f'{user}:{decoded_hash}')
        complete_user = False
        user = ''
        nt_hash = ''

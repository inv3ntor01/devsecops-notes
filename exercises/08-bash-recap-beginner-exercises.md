# Bash Recap — Beginner Exercises

**Date:** 2026-06-29  
**Level:** Beginner  
**Type:** Hands-on Exercises  
**Duration:** 60-90 minutes

---

## Exercise 1: Variables & String Manipulation

Create a bash script that:
- Stores your name in a variable `NAME`
- Stores your role in a variable `ROLE`
- Prints a greeting: `"Hello, I am [NAME] and I work as a [ROLE]"`

**Your solution:**
```bash
#!/usr/bin/env bash

NAME="Loki"
ROLE="Asguard"

echo "Hello, I am $NAME and I work as a $ROLE"
```

---

## Exercise 2: File Testing

Write a script that checks if a file called `config.txt` exists in the current directory. If it does, print `"Config file found"`, otherwise print `"Config file not found"`.

**Hint:** Use the `[ -f ]` or `[[ ]]` test syntax.

**Your solution:**
```bash
[ -f config.txt ] && echo "Config file found" || echo "Config file not found"
```

---

## Exercise 3: Exit Codes

Create a script that:
1. Runs `ls /nonexistent-folder`
2. Captures the exit code using `$?`
3. Prints the exit code
4. If the exit code is not 0, print `"Command failed"`, otherwise print `"Command succeeded"`

**Your solution:**
```bash
#!/usr/bin/env bash

ls /nonexistent-folder 2>/dev/null
EXIT_CODE=$?

echo "Exit code: $EXIT_CODE"

if [ $EXIT_CODE -eq 0 ]; then 
    echo "Command Succeeded" 
else 
    echo "Command failed"
fi

```

---

## Exercise 4: Command Substitution

Write a script that:
- Gets the current date using `date +%Y-%m-%d`
- Stores it in a variable
- Prints `"Today's date is: [DATE]"`

**Your solution:**
```bash
DATE=$(date +%Y-%m-%d)

echo "Today's date is: $DATE"
```

---

## Exercise 5: Conditional Logic with AND/OR

Write a script that takes a file path as an argument and:
- Checks if the file exists AND is readable
- If both are true, print `"File exists and is readable"`
- Otherwise, print `"File does not exist or is not readable"`

**Bonus:** Also check if it's a regular file (not a directory).

**Your solution:**
```bash
if [ -f "file/file.txt" ] && [ -r "file/file.txt" ]; then;
    echo "File exists and is readable"
else
    echo "File does not exist or is not readable"
```

---

## Exercise 6: Basic Loop — Counting

Write a script that prints numbers from 1 to 5 using a `for` loop.

**Your solution:**
```bash
for i range(1..5); do
    echo "$i"
done
```

---

## Exercise 7: Loop Through Files

Create a directory with a few text files, then write a script that:
- Loops through each `.txt` file in the current directory
- Prints the filename and its line count

**Hint:** Use `for file in *.txt` and `wc -l`

**Your solution:**
```bash
for file in *.txt; do
    lines=$(wc -l < "$file")
    echo "$file: $lines lines"
done
```

---

## Exercise 8: While Loop — Read File

Create a file called `users.txt` with the following content:
```
alice
bob
charlie
```

Write a script that:
- Reads the file line by line
- Prints each name with a greeting: `"Welcome, [NAME]!"`

**Your solution:**
```bash
cat > users.txt << 'EOF'
alice
bob
charlie
EOF

while read -r line; do
    echo "Welcome, $line!"
done < users.txt
```

---

## Exercise 9: User Input

Write a script that:
- Prompts the user: `"Enter your favorite programming language:"`
- Reads the input into a variable `LANG`
- Prints: `"You chose: [LANG]"`

**Hint:** Use `read`

**Your solution:**
```bash
read -p "Enter your favorite programming language: " LANG
echo "You chose: $LANG"
```

---

## Exercise 10: Functions

Create a bash function called `greet()` that:
- Takes a name as an argument
- Prints: `"Hello, [NAME]! Welcome to Bash scripting."`

Then call the function with the name `"DevOps Engineer"`.

**Your solution:**
```bash
greet() {
    echo "Hello, $1! Welcome to Bash scripting."
}

greet("DevOps Engineer")
```

---

## Exercise 11: Combining Conditions

Write a script that checks if:
- A directory `/tmp/backup` exists
- A file `/tmp/backup/data.tar.gz` exists inside it
- The file is larger than 100MB

Print appropriate messages for each check.

**Your solution:**
```bash
i dont know
```

---

## Exercise 12: Array Basics

Create a bash script that:
- Defines an array of 3 tools: `bash`, `docker`, `kubernetes`
- Loops through the array
- Prints each tool with an index: `"Tool 0: bash"`, etc.

**Your solution:**
```bash
i dont know
```

---

## Exercise 13: String Comparison

Write a script that:
- Takes a string as an argument
- Checks if it equals `"admin"`
- If yes, print `"You have admin access"`
- If no, print `"Access denied"`

**Your solution:**
```bash
i dont know
```

---

## Exercise 14: Piping & Text Processing

Write a script that:
- Lists all files in the current directory
- Pipes the output to `grep` to find files containing `"test"` in their name
- Counts how many matches were found

**Your solution:**
```bash
i dont know
```

---

## Exercise 15: Error Handling with Trap

Create a script that:
- Sets up a trap to catch the EXIT signal
- Prints `"Cleanup: Script is exiting"` when the script ends
- Runs normally, then exits

**Your solution:**
```bash
i dont know
```

---

## Bonus Challenge: Putting It All Together

Write a script called `deploy.sh` that:
1. Checks if a directory `./app` exists
2. If it doesn't exist, create it
3. Creates a file `app/version.txt` with the current date
4. Reads the version file
5. Prints: `"Deployment complete. Version: [DATE]"`
6. Cleans up on exit with a trap

**Your solution:**
```bash

```

---

## Answer Key (Self-Check)

*Refer to the answer sheet or instructor feedback for solutions.*


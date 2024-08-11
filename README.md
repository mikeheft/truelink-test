# README

## Prerequisites
- `ruby 3.3.0`

## Setup

- Clone the repo; `git clone git@github.com:mikeheft/truelink.git`
- cd into repo; `cd truelink`
- run setup script; `./setup.sh`
  - This creates a simlink that allows for the desired usage outlined in the project brief outlined [below](#cli)

## Usage
### CLI

```sh
# path to file being the path to the file you wish to find the best pairs
# balance being a positive integer; dollars as cents, e.g., 1000 == $10
find-pairs <path to file> <balance>
# Example output...
#=> Candy Bar 500, Earmuffs 2000
```

### Testing
To run the test suite, simply run `bundle exec rspec`

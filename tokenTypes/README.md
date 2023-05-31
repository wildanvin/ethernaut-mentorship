- In order to the `mintRandomType` function to revert we need that `pickRandomTokenType` returns `type(uint256).max`
- One trivial solution is: in the constructor we pass the value of 1. By doing that the for loop in L40 never executes, `pickRandomTokenType` returns `type(uint256).max` and `mintRandomType` reverts

- For other cases, if we want `pickRandomTokenType` to return `type(uint256).max` we need to avoid to enter in the `if` statements in lines 36 and 42. In other words we need that the `checkValidValue` function returns `false` in both lines:

  ```
  L36 checkValidValue(randomNumberModded + 1)
  L42 checkValidValue(tokenType == true)
  ```

  But `tokenType` is equal to `randomNumberModded + 1 + 1`. So we need:

  ```
  L36 checkValidValue(randomNumberModded + 1)
  L42 checkValidValue(randomNumberModded + 1 + 1)
  ```

  To return false.
  In other words, we need that the `checkValidValue` fuction returns `false` for 2 consecutive values. But that is not possible, at least not in the way `checkValidValue` is coded.

  Let's review `checkValidValue`. It returns `true` if a product is even and `false` if it is odd. The main formula can be simplified to:

  ```
  (x + input)*(x + input)
  (x + input)^2
  ```

  where x is `block.timestamp + block.number + tx.gasprice`. So if `(x + 1)^2` returns `false`, `(x + 2)^2` will return `true`. I don't have a mathemathical proof but you can try with some values. For 2 consecutives values this function will return different results.
  So it is not possible for this function to revert

- I also tried foundry's fuzzer with 100000 runs for the `mintRandomType` function, it didn't work.

I was doing tests in this [repo](https://github.com/wildanvin/ethernaut-mentorship/tree/main/tokenTypes)

For testing just a single test in foundry:

```bash
forge test --mt <your_pattern> -vv
```

`mt` stands for `match-test`

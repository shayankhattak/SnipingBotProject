// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV3Router {
    function exactInputSingle(
        uint256 amountIn,
        address tokenIn,
        address tokenOut,
        address to,
        uint24 fee,
        uint160 sqrtPriceLimitX96
    ) external payable returns (uint256 amountOut);

    function exactOutputSingle(
        uint256 amountOut,
        address tokenIn,
        address tokenOut,
        address to,
        uint24 fee,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256 amountIn);
}

contract SnipingBot {
    address public owner;
    IUniswapV3Router public uniswapRouter;

    event Sniped(address token, uint amountIn, uint amountOut);
    event Sold(address token, uint amountIn, uint amountOut);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _uniswapRouter) {
        owner = msg.sender;
        uniswapRouter = IUniswapV3Router(_uniswapRouter);
    }

    receive() external payable {}

    function snipe(address tokenIn, address tokenOut, uint24 fee, uint amountIn, uint amountOutMin, uint160 sqrtPriceLimitX96) external onlyOwner {
        uint amountOut = uniswapRouter.exactInputSingle(
            amountIn,
            tokenIn,
            tokenOut,
            address(this),
            fee,
            sqrtPriceLimitX96
        );
        require(amountOut >= amountOutMin, "Insufficient output amount");
        emit Sniped(tokenOut, amountIn, amountOut);
    }

    function sell(address tokenIn, address tokenOut, uint24 fee, uint amountOut, uint amountInMax, uint160 sqrtPriceLimitX96) external onlyOwner {
        uint amountIn = uniswapRouter.exactOutputSingle(
            amountOut,
            tokenIn,
            tokenOut,
            address(this),
            fee,
            sqrtPriceLimitX96
        );
        require(amountIn <= amountInMax, "Excessive input amount");
        emit Sold(tokenOut, amountIn, amountOut);
    }

    function withdrawETH(uint amount) external onlyOwner {
        payable(owner).transfer(amount);
    }

    function withdrawToken(address token, uint amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }
}

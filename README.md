# My Experiences with the Colorlight 5A-75B v8.2

> ## ⚠️ IMPORTANT - PLEASE READ FIRST
> 
> **Before using this repository, all thanks and credit for the initial discovery and pinout documentation go to [q3k](https://github.com/q3k) and the [Chubby75 contributors](https://github.com/q3k/chubby75/graphs/contributors).**
> 
> [Chubby75](https://github.com/q3k/chubby75) is the foundational reverse engineering work for 5A-75B boards. This repository is simply my personal bug tracker and experience log built upon their excellent research.
> 
> ---
> *"Without Chubby75, none of this would be possible. Please visit and support them first."*

---

After many weeks of work, I wanted to share my journey with this FPGA board, including the bugs I found and how I solve them.


## 🐛 Bugs and Issues I Encountered

### 1. No Pinout for JTAG
- **The Problem:** This is the problem with the V8.2 board. The JTAG pins do not have a pin headers.
- **Things You Need:**
    - Someone who knows soldering. or
    - male-to-male pin headers.
    - soldering iron.
    - solder and soldering flux.
    - some time.
    - patience.
    - **Current Status:** **SOLVED**. You just need someone soldering pin headers to the board or do it by yourself. It's not that hard.

### 2. IceStudio Bugs
- **The Problem:** There is some problems i faced while installing or using IceStudio to program the board.
- **Current Status:** **PARTIALLY RESOLVED**. check [icestudio-bugs](./bugs/icestudio-bugs.md) for more details.


## 📚 Resources I Used
- [LiteX-Hub Boards](link)
- [Chubby75 Reverse Engineering Project](link)
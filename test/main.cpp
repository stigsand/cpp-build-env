#include <print>
//#include <generator>
//#include <ranges>

/*std::generator<int> fibonacci()
{
    co_yield 1;
    co_yield 2;
    co_yield 3;
    co_yield 4;
    co_yield 5;
}*/

int main()
{
    std::println("{}", 26);
    //std::println("{}", fibonacci() | std::ranges::take(4));
}

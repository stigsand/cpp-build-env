#include <functional>
#include <print>

int main()
{
    std::move_only_function<void ()> f = [] { std::println("Hi {}", 24); };
    f();
}

//Minsky
#include <iostream>
using namespace std;

int main() {
  struct foo_t {
    int x[100];
    int var1;
    int y[10];
    } foo;
  int var2;
  long i;
  int *p, *q;
  short int *s;
  long int *l;
  // char *a;  //MOD
  // string *b;  //MOD
  // double *c;  //MOD
  struct foo_t bar[50];

  for (i=0; i<100; i++) foo.x[i]=100+i;
  for (i=0; i<10; i++)  foo.y[i]=200+i;
  foo.var1 = 250;

  // cout << sizeof(*s) << "\n"; //2B
  // cout << sizeof(*p) << "\n"; //4B
  // cout << sizeof(*l) << "\n"; //8B
  // cout << sizeof(*a) << "\n"; //MOD 1B
  // cout << sizeof(*b) << "\n"; //MOD 32B
  // cout << sizeof(*c) << "\n"; //MOD 8B
  q = (int *) &foo;    cout << q << "\n";
  p=&(foo.x[16]);       cout << *p << "\n";
  // POINT 1
  q = (int *) &var2;   cout << q << "\n";
  q = p+16;            cout << *q << "\n";
  i = ((long) p) + 16;
  q = (int *) i;       cout << *q << "\n";
  s = (short *) i;     cout << *s << "\n";
  l = (long *) i;      cout << *l << "\n";
  cout << "EXPLAIN PART" << "\n";
  q = p+95;            cout << *q << "\n";  // EXPLAIN
  q = p+98;            cout << *q << "\n";
  i = ((long) p) + 17;
  // q = (int *) i;       cout << *q << "\n";
  // q = p + _______;     cout << *q << "\n";
  // q = (int *) (((long) p) + ______);  cout << *q << "\n";
  // p = (int *) bar;
  // *(p + _______) = 500; cout << bar[8].var1 << "\n";

  return 0;
}
# %%
import matplotlib.pyplot as plt
import numpy as np

# %%
# Create a simple plot to test image display
x = np.linspace(0, 10, 100)
y = np.sin(x)

plt.figure(figsize=(10, 6))
plt.plot(x, y, 'b-', linewidth=2, label='sin(x)')
plt.title('Test Plot for pyworks.nvim')
plt.xlabel('x')
plt.ylabel('sin(x)')
plt.grid(True, alpha=0.3)
plt.legend()
plt.show()

# %%
# Create another plot to test multiple cells
x2 = np.linspace(0, 4*np.pi, 100)
y2 = np.cos(x2) * np.exp(-x2/10)

plt.figure(figsize=(10, 6))
plt.plot(x2, y2, 'r-', linewidth=2, label='cos(x) * exp(-x/10)')
plt.title('Damped Cosine Wave')
plt.xlabel('x')
plt.ylabel('y')
plt.grid(True, alpha=0.3)
plt.legend()
plt.show()

# %%
print("pyworks.nvim test complete!")
print("If you can see the plots above, image display is working correctly.")
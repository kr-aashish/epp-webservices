module.exports = {
    env: {
        browser: true,
        es2021: true,
        'jest/globals': true
    },
    extends: [
        'eslint:recommended',
        'plugin:@typescript-eslint/recommended',
        'plugin:prettier/recommended',
        'airbnb-base',
        'prettier'
    ],
    overrides: [
        {
            env: {
                node: true
            },
            files: ['.eslintrc.{js,cjs}'],
            parserOptions: {
                sourceType: 'script'
            }
        }
    ],
    parser: '@typescript-eslint/parser',
    parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module'
    },
    plugins: ['@typescript-eslint', 'unused-imports', 'jest'],
    rules: {
        indent: ['error', 4],
        'linebreak-style': ['error', 'unix'],
        quotes: ['error', 'single'],
        semi: ['error', 'always'],
        'no-console': 'error',
        'jest/no-disabled-tests': 'warn',
        'jest/no-focused-tests': 'error',
        'jest/no-identical-title': 'error',
        'jest/prefer-to-have-length': 'warn',
        'jest/valid-expect': 'error',
        'comma-dangle': ['error', 'never'],
        'import/no-unresolved': [0, { caseSensitive: false }],
        'import/extensions': [0],
        'no-array-constructor': 'off',
        'no-param-reassign': 'off',
        'no-plusplus': 'off',
        'no-underscore-dangle': 'off',
        'max-classes-per-file': ['error', 1000],
        '@typescript-eslint/ban-types': 'off',
        'no-new-wrappers': 'off'
    }
};
